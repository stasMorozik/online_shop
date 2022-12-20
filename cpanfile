requires 'DateTime';
requires 'Try::Tiny';
requires 'Moo';
requires 'Email::Address';
requires 'Email::Valid';
requires 'Crypt::Password';
requires 'UUID::Tiny';
requires 'Crypt::Random';
requires 'JSON::WebToken';
requires 'Rose::DB::Object';
requires 'DBD::Pg';
requires 'Data::Monad::Either';

feature 'Test::More', 'Test::More support' => sub {
    requires 'Test::More';
};