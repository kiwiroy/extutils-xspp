#!/usr/bin/perl -w

use strict;
use warnings;
use t::lib::XSP::Test tests => 4;

run_diff xsp_stdout => 'expected';

__DATA__

=== Renamed function (also in different package)
--- xsp_stdout
%module{Foo};
%package{Foo::Bar};
%typemap{int}{simple};

%name{boo} int foo(int a);
%name{moo::boo} int foo(int a);
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo::Bar

int
boo( a )
    int a
  CODE:
    RETVAL = foo( a );
  OUTPUT: RETVAL

MODULE=Foo PACKAGE=moo

int
boo( a )
    int a
  CODE:
    RETVAL = foo( a );
  OUTPUT: RETVAL

=== Renamed method
--- xsp_stdout
%module{Foo};

%typemap{int}{simple};

class Foo
{
    %name{bar} int foo( int a );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

int
Foo::bar( a )
    int a
  CODE:
    RETVAL = THIS->foo( a );
  OUTPUT: RETVAL

=== Renamed constructor
--- xsp_stdout
%module{Foo};

%typemap{int}{simple};

class Foo
{
    %name{newFoo} Foo( int a );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

static Foo*
Foo::newFoo( a )
    int a
  CODE:
    RETVAL = new Foo( a );
  OUTPUT: RETVAL

=== Renamed class
--- xsp_stdout
%module{Foo};

%typemap{int}{simple};
%typemap{void}{simple};

%name{Bar::Baz} class Foo
{
    void foo();
    %name{foo_int} int foo( int a );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Bar::Baz

void
Foo::foo()

int
Foo::foo_int( a )
    int a
  CODE:
    RETVAL = THIS->foo( a );
  OUTPUT: RETVAL
