package PostgresAdapters::Object;
 
use PostgresAdapters::DB;
 
use base qw(Rose::DB::Object);
 
sub init_db { PostgresAdapters::DB->new }

1;