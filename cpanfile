requires 'DateTime';
requires 'Try::Tiny';
requires 'Moo';
requires 'Email::Address';
requires 'Email::Valid';
requires 'Crypt::Password';

feature 'Test::More', 'Test::More support' => sub {
    requires 'Test::More';
};