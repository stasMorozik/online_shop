use strict;
use warnings;

use lib '../t';

use Test::More;

use Core::User::TestUserEntity;
use Core::User::TestTokenEntity;
use Core::ConfirmationCode::TestConfirmationCodeEntity;
use Core::ConfirmationCode::TestCreatingUseCase;
use Core::User::TestRegistrationUseCase;
use Core::User::TestAuthenticationByPasswordUseCase;
use Core::User::TestAuthenticationByCodeUseCase;
use Core::User::TestRefreshTokenUseCase;
use Core::User::TestAuthorizationUseCase;

use PostgresAdapters::User::TestCreatingAdapter;

done_testing(106);
