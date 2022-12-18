package PostgresAdapters::User::OrmEntities::UserOrmEntity;

use base qw(PostgresAdapters::Object);
 
__PACKAGE__->meta->setup
(
  table      => 'users',
  columns    => [ qw(id name last_name email phone password created) ],
  pk_columns => 'id',
  unique_key => 'email',
);

__PACKAGE__->meta->make_manager_class('users');

1;