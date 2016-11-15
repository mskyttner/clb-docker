function update-cli() {

    echo "Updating $1"

    echo -n "	"
    wget --no-verbose --output-document $1.new "$2"

    if diff $1 $1.new &> /dev/null; then
        rm --force $1.new
        echo "	$1 does not need to be updated"
    else
        mv --force $1.new $1
        echo "	$1 has been updated"
    fi

    echo -n "	$1 "
    unzip -p $1 META-INF/MANIFEST.MF | grep Implementation-Version || echo 'n/a'
}
