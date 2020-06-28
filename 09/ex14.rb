require 'sqlite3'
require 'rexml/document'
require 'rexml/formatters/pretty'

class XPathToSQL

    # イニシャライザ
    def initialize(xpath, db_path)
        @xpath = xpath
        @db = SQLite3::Database.new(db_path)
    end

    # WHERE句生成
    def mk_where(label_size)
        # ルート直下のみの時をセット
        a = <<~WHERE
            n1.id = 1
            and n1.name = ?
        WHERE
        # 深さ1超過のときの処理を追記
        if label_size != 1
            a += (1...label_size).map{
                <<~ADD
                    and e#{_1}.parent = n#{_1}.id
                    and e#{_1}.child = n#{_1.next}.id
                    and n#{_1.next}.name = ?
                ADD
            } * ?\n
        end
        return a
    end

    # FROM句生成
    def mk_from(label_size)
        if label_size == 1
            'node n1'
        else
            (1..label_size).map{
                "node n#{_1}, edge e#{_1}"
            }.join(?,).sub(/, edge e\d+$/, "") # 末尾の/edge n\d/を削除
        end
    end

    # 今回受け付けるXPathは
    # <Path> ::= "/child::"
    # <XPath> ::= <Path>+
    def xpath_chk(xpath, steps)
        xpath != ?/ && steps.any?{_1 !~ /^child::/}
    end

    # XPathをSQLにパース
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

    # XPathをパースしたSQLを実行
    def lookup(sql, labels)
        result = []
        @db.transaction{
            @db.execute(sql, *labels) {
              result << "%s" % _1[0]
            }
        }
        return result
    end

    # ヒットしたidを持つ要素以下の木に対応するXMLを出力
    def printnode(id, out)
        current, child = [], []
        current = @db.execute(<<~SQL, id)
            SELECT name, type FROM node WHERE id = ?;
        SQL
        if current[0][1] == 'element'
            out << '<%s>' % current[0][0]
            child = @db.execute(<<~SQL, id)
                SELECT child FROM edge WHERE parent = ?;
            SQL

            child.each {|row|
                printnode(row[0].to_i, out)
            }
            out << '</%s>' % current[0][0]
        else current[0][1] == 'text'
            out << current[0][0]
        end
    end

    # XMLをきれいにして表示
    def printexe(id)
        res = ""
        @db.transaction{
            printnode(id, res)
        }

        REXML::Formatters::Pretty.new.write(
            REXML::Document.new(res), $>
        )
        $> << ?\n
    end
end

# $ ruby ex14.rb "/child::books"
# $ ruby ex14.rb "/child::books/child::book"
# $ ruby ex14.rb "/child::books/child::book/child::title"

def main
    if (argnum = $*.size) != 2
        errmsg = 'wrong number of arguments'\
                 "(given #{argnum}, expected 2)."
        raise ArgumentError, errmsg
        return 1
    end
    x = XPathToSQL.new(*$*)
    conv_sql = x.xpath_to_sql
    res_ids = x.lookup(conv_sql[:sql], conv_sql[:labels])
    res_ids.each{
        puts "=== #{_1} ==="
        x.printexe(_1)
    }
    return 0
end

exit(main)