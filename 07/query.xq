declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "indent=yes";

<books>
{
    for $i in doc("jbisc10.xml")//book,
        $j in doc("price.xml")//book
    where $i/bibRecord = $j/bibRecord
    return <book>{$i/title,$j/price }</book>
}
</books>