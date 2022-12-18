requires 'DateTime';
requires 'Try::Tiny';
requires 'Moo';
requires 'Email::Address';
requires 'Email::Valid';
requires 'Crypt::Password';
requires 'UUID::Generator::PurePerl';
requires 'Data::Validate::UUID';
requires 'Crypt::Random';
requires 'JSON::WebToken';
requires 'Rose::DB::Object';
requires 'DBD::Pg';

feature 'Test::More', 'Test::More support' => sub {
    requires 'Test::More';
};