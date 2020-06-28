require "sqlite3"

class XPathToSQL

    def initialize(xpath, db_path)
        @xpath = xpath
        @db = SQLite3::Database.new(db_path)
    end

    def mk_where(label_size)
        a = <<~WHERE
            n1.id = 1
            and n1.name = ?
        WHERE
        if label_size != 1
            a += (1...label_size).map{
                <<~ADD
                    and e#{_1}.parent = n#{_1}.id
                    and e#{_1}.child = n#{_1.next}.id
                    and n#{_1.next}.name = ?
                ADD
            }*?\n
        end
        return a
    end

    def mk_from(label_size)
        if label_size == 1
            'node n1'
        else
            (1..label_size).map{
                "node n#{_1}, edge e#{_1}"
            }.join(?,).sub(/, edge e\d+$/, "")
        end
    end

    def xpath_chk(xpath, steps)
        xpath != ?/ && steps.any?{_1 !~ /^child::/}
    end

    def xpath_to_sql()
        labels = []
        steps = @xpath.split(?/).drop(1)
        raise SyntaxError, @xpath if xpath_chk(@xpath, steps)
        steps.map{_1[7..]}.each { 
            labels << _1
        }
        q_num = labels.size
        sql = <<~SQL
        SELECT n#{q_num}.id
        FROM #{mk_from(q_num)}
        WHERE #{mk_where(q_num)};
        SQL
        return {:sql => sql, :labels => labels}
    end

    def lookup(sql, labels)
        result = []
        pp [sql, labels]
        @db.transaction{
            @db.execute(sql, *labels) {
              result << "%s" % _1[0]
            }
        }
        @db.close
        return result
    end
end

# $ ruby ex-10.rb "/child::books"
# $ ruby ex-10.rb "/child::books/child::book"
# $ ruby ex-10.rb "/child::books/child::book/child::title"

def main
    if (argnum = $*.size) != 1
        errmsg = "wrong number of arguments"\
                 "(given #{argnum}, expected 1)."
        raise ArgumentError, errmsg
    end
    x = XPathToSQL.new($*[0], "test.db")
    conv_sql = x.xpath_to_sql
    puts x.lookup(conv_sql[:sql], conv_sql[:labels])
end

main
