require 'sqlite3'
require 'rexml/document'
require 'rexml/formatters/pretty'

def printnode(id, db, out)
    current, child = [], []
    current = db.execute(<<~SQL, id)
        select name,type from node where id = ?;
    SQL
    if current[0][1] == "element"
        out << "<%s>" % current[0][0] # 開始タグ
        child = db.execute(<<~SQL, id)
            select child from edge where parent = ?;
        SQL
        # 子要素の再帰探索
        child.each {|row|
            printnode(row[0].to_i, db, out)
        }
        out << "</%s>" % current[0][0] # 終了タグ
    else current[0][1] == "text"
        out << current[0][0] # テキストノード
    end
end

def printexe
    db = SQLite3::Database.new("test.db")
    res = ""
    db.transaction{
        printnode(1, db, res)
    }
    db.close

    REXML::Formatters::Pretty.new.write(
        REXML::Document.new(res), $>
    )
    $> << ?\n
end
printexe