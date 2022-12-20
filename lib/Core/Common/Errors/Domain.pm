package Core::Common::Errors::Domain;

use Moo;

has message => (
  is => 'ro',
  required => 1
);

1;