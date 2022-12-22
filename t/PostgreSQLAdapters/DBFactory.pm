package PostgreSQLAdapters::DBFactory;

use DBI;

sub factory {
  return DBI->connect('dbi:Pg:database=online_shop;host=localhost;', 'db_user', '12345', {
    PrintError => 0,
    AutoCommit => 0
  });
}

1;