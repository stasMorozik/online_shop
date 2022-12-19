package Core::Token::Entity;

use Moo;
use Scalar::Util qw(reftype blessed);
use JSON::WebToken;
use Try::Tiny;

use Core::User::Entity;
use Core::Common::Errors::Domain;
use Core::Common::ValueObjects::Email;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid secret key'})
  }

  unless ($args->{refresh_secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh secret key'})
  }

  unless ($args->{user}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid User'})
  }

  unless (blessed $args->{user}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid User'}); 
  }

  unless ($args->{user}->isa('Core::User::Entity')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid User'}); 
  }

  return Core::Token::Entity->new({
    'token' => encode_jwt(
      {
        'iss' => $args->{user}->email->value,
        'exp' => time() + 600
      }, 
      $args->{secret_key}
    ),
    'refresh_token' => encode_jwt(
      {
        'iss' => $args->{user}->email->value,
        'exp' => time() + 86400
      }, 
      $args->{refresh_secret_key}
    )
  });
}

sub refresh {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid secret key'});
  }

  unless ($args->{refresh_secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh secret key'});
  }

  unless ($args->{refresh_token}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh token'});
  }

  my $claims;
  
  try {
    $claims = decode_jwt($args->{refresh_token}, $args->{refresh_secret_key});
  } catch {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh token'});
  };

  unless ($claims->{iss}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh token'});
  }

  unless ($claims->{exp}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh token'});
  }

  if (time() >= $claims->{exp}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh token'});
  }

  return Core::Token::Entity->new({
    'token' => encode_jwt(
      {
        'iss' => $claims->{iss},
        'exp' => time() + 600
      }, 
      $args->{secret_key}
    ),
    'refresh_token' => encode_jwt(
      {
        'iss' => $claims->{iss},
        'exp' => time() + 86400
      }, 
      $args->{refresh_secret_key}
    )
  });
}


sub parse {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid secret key'});
  }

  unless ($args->{token}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid token'});
  }

  my $claims;
  
  try {
    $claims = decode_jwt($args->{token}, $args->{secret_key});
  } catch {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid token'});
  };

  unless ($claims->{iss}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid token'});
  }

  unless ($claims->{exp}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid token'});
  }

  if (time() >= $claims->{exp}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid token'});
  }

  return Core::Common::ValueObjects::Email->factory($claims->{iss});
}

has token => (
  is => 'ro'
);

has refresh_token => (
  is => 'ro'
);

1;