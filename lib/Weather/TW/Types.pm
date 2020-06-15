package Weather::TW::Types {
    use Moose::Util::TypeConstraints;

    subtype 'CWBAPIAuthKey', as 'Str', where { /[A-Z0-9\-]{40}/ };
};

1;
