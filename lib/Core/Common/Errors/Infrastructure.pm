package Core::Common::Errors::Infrastructure;

use Moo;

has message => (
  is => 'ro',
  required => 1
);

1;