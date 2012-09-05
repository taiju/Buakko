package Buakko;
use strict;
use warnings;
use utf8;
use 5.008001;
use open OUT => qw/:encoding(utf-8) :std/;
use Cwd ();
use FindBin;
use Path::Class;
use Parse::RecDescent;
our $VERSION = '0.01';

my $grammar = <<'GRAMMAR';
    expression : "(" operator attributes(?) arguments(s?) ")" {
        my $name = $item[2];
        my $attributes = (scalar @{$item[3]}) ? $item[3][0] : "";
        my $value = (scalar @{$item[4]}) ? join "", @{$item[4]} : "";
        my $html = "";
        if ($name eq "xml") {
            if ($attributes) {
                $html .= "<?xml $attributes?>$value";
            }
            else {
                $html .= ">$value";
            }
        }
        else {
            if ($name eq "html") {
                $html .= "<!doctype html>";
            }
            $html .= "<$name";
            if ($attributes) {
               $html .= " $attributes"; 
            }
            if ($value) {
                $html .= ">$value</$name>";
            }
            else {
                $html .= " />";
            }
        }
        $return = $html;
    } | <error>
    operator    : xml | html | element {
        $return = $item[1];
    }
    xml        : "xml" {
        $return = $item[1];
    }
    html       : "html" {
        $return = $item[1];
    }
    element    : /(mt:)?\w+/ {
        $return = $item[1];
    }
    arguments  : expression | comment | text
    text       : /".*?[^\\]"/ {
        $item[1] =~ s/\\"/%ESCAPED%/g;
        $item[1] =~ s/"//g;
        $item[1] =~ s/%ESCAPED%/"/g;
        $return = $item[1];
    }
    attributes : "(" pair(s?) ")" {
        $return = join " ", @{$item[2]};
    }
    pair       : key value {
        $return = "$item[1]=" . '"' . $item[2] . '"';
    }
    key        : /^@[\w:]+/ {
        $item[1] =~ s/^@//;
        $return = $item[1];
    }
    value      : /".*?"/ {
        $item[1] =~ s/"//g;
        $return = $item[1];
    }
    comment    : /^#.+\n/ {
        $item[1] =~ s/^#\s*//;
        $item[1] =~ s/\n//g;
        $return = "<!--$item[1]-->";
    }
GRAMMAR

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{_current} = Cwd::getcwd;
    $self;
}

sub run {
    my $self = shift;
    my $file = shift;
    my $input = "$self->{_current}/$file";
    my $response = $self->parse_file($input) or die "Compile failed.";
    print $response;
}

sub parse {
    my $self = shift;
    my $source = shift;
    my $parser = Parse::RecDescent->new( $grammar ) or die "Bad grammar";
    $parser->expression($source);
}

sub parse_file {
    my $self = shift;
    my $input = shift;
    my $file = file($input);
    my $source = $file->slurp(iomode => "<:encoding(utf-8)");
    $self->parse($source);
}

1;
__END__

=head1 NAME

Buakko - Simple s-expression to (X|HT)ML converter.

=head1 SYNOPSIS

  $ buakko hoge > hoge.html

=head1 INSTALL

=head1 DESCRIPTION

Convert S-Expression to (X|HT)ML.

=head1 AUTHOR

taiju E<lt>higashi@taiju.infoE<gt>

=head1 LICENSE

Copyright (c) 2012, taiju. All rights reserved.

MIT License.

=cut
