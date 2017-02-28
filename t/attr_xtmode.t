use strict;
use warnings;

use Test::More;
use Test::File::ShareDir::Dist { 'Dist-Zilla-Plugin-Test-Compile-PerFile' => 'share' };
use Path::Tiny qw( path );
use Test::DZil qw( simple_ini Builder );

# ABSTRACT: Basic test

my $ini = simple_ini( ['GatherDir'], [ 'Test::Compile::PerFile', { xt_mode => 1 } ], );
my $good_sample = <<'EOF';
package Good;

# This is a good file

1
EOF

my $tzil = Builder->from_config(
  { dist_root => 'invalid' },
  {
    add_files => {
      path( 'source', 'dist.ini' ) => $ini,
      path( 'source', 'lib', 'Good.pm' ) => $good_sample,
    },
  }
);
$tzil->chrome->logger->set_debug(1);
$tzil->build;

ok( path( $tzil->tempdir, 'build', 'xt', 'author', '00-compile', 'lib_Good_pm.t' )->exists,
  "Generated file xt/author/00-compile/lib_Good_pm.t" );

done_testing;
