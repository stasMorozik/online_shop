package PostgresAdapters::DB;
 
use base qw(Rose::DB);
 
__PACKAGE__->use_private_registry;
 
__PACKAGE__->register_db(
  driver   => 'pg',
  database => 'online_shop',
  host     => 'localhost',
  username => 'db_user',
  password => '12345',
);

1;