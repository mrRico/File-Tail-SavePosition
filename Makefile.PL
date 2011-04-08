use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'File::Tail::SavePosition',
    VERSION_FROM      => 'lib/File/Tail/SavePosition.pm', # finds $VERSION
    PREREQ_PM         => {
        'Sub::Install' => 0,
        'File::Tail' => 0
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/File/Tail/SavePosition.pm', # retrieve abstract from module
       AUTHOR         => 'mr.Rico <catamoose at yandex.ru>') : ()),
);
