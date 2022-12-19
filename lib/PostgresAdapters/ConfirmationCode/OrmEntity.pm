package PostgresAdapters::ConfirmationCode::OrmEntity;

use base qw(PostgresAdapters::Object);
 
__PACKAGE__->meta->setup
(
  table      => 'codes',
  columns    => [ qw(email code created) ],
  unique_key => 'email'
);

__PACKAGE__->meta->make_manager_class('codes');

1;