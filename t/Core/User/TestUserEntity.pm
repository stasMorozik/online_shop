package Core::User::TestUserEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;
use UUID::Generator::PurePerl;

my $uid_gen = UUID::Generator::PurePerl->new();

require_ok( 'Core::User::UserEntity' );

my $user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::UserEntity') eq 1, 'New User');

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'nam' => 'Some',
    'last_name' => 'Some', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty name');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Som1',
    'last_name' => 'Some', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid name');
};

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай-Яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай Яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Николай яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Николай яркий1',
    'last_name' => 'Минин', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid russian name');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Николай-яркий1',
    'last_name' => 'Минин', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid russian name');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Sqwertyuiopasdfghjklzxcvbnmqasdf',
    'last_name' => 'Some', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo long name');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'emai' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty email');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => '~@@#$@hevanet.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'password' => '.,!?$@&-*_', 
  'phone' => '+79683456782'
});
ok($user->isa('Core::User::UserEntity') eq 1, 'Valid password');

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwor' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty password');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '^[]()', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid password');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => 'пароль123', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid password');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '123456789012345678901234567', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo long password');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phone' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo short password');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some', 
    'last_name' => 'Last',
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phone' => '+7968345678'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid phone number');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some', 
    'last_name' => 'Last',
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phone' => '+796834567826'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid phone number');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 
    'name@gmail.com', 
    'passwors' => '1234', 
    'phone' => '79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid phone number');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phone' => 79683456782
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid phone number');
};

try {
  Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phon' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty phone number');
};

try {
  Core::User::UserEntity->new({
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phon' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty id');
};

try {
  Core::User::UserEntity->new({
    'id' => '',
    'name' => 'Some',
    'last_name' => 'Last', 
    'email' => 'name@gmail.com', 
    'passwors' => '1234', 
    'phon' => '+79683456782'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid id');
};


$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->validate_password('qwe-rty!12$') eq 1, 'Validate password');

try {
  $user = Core::User::UserEntity->new({
    'id' => $uid_gen->generate_v4(),
    'name' => 'Some', 
    'last_name' => 'Some', 
    'email' => 'name@gmail.com', 
    'password' => 'qwe-rty!12$', 
    'phone' => '+79683456782'
  });

  $user->validate_password('qwe-rty!12$');
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Wrong password');
};

$user = Core::User::UserEntity->new({
  'id' => $uid_gen->generate_v4(),
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->update({'name' => 'Some'}) eq 1, 'Update name');

ok($user->update({'last_name' => 'Some'}) eq 1, 'Update last name');

ok($user->update({'email' => 'name@gmail.com'}) eq 1, 'Update last email');

ok($user->update({'password' => 'qwe-rty!12$'}) eq 1, 'Update last password');

ok($user->update({'phone' => '+79683456782'}) eq 1, 'Update last phone');

1;
