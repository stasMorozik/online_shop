use strict;
use warnings;

use lib '../t';

use Test::More;

use Core::User::TestEntity;
use Core::ConfirmationCode::TestEntity;
use Core::ConfirmationCode::TestCreating;
use Core::Token::TestEntity;
use Core::Token::TestRefreshToken;
use Core::User::TestRegistration;
use Core::User::TestAuthenticationByPassword;
use Core::User::TestAuthenticationByCode;
use Core::User::TestAuthorization;

use PostgresAdapters::User::TestCreating;
use PostgresAdapters::User::TestGettingByEmail;

done_testing(113);
