package File::Tail::SavePosition;

use strict;
use warnings;

our $VERSION = '0.01';

use Sub::Install;

=head1 NAME

File::Tail::SavePosition

=head1 DESCRIPTION

Extends File::Tail to save the cursor position in file.
File::Tail::SavePosition saved you from re-reading the file from the beginning, 
when system restart

=SYNOPSIS
    
    use File::Tail;
    use File::Tail::SavePosition;
    
    my $tail = File::Tail->new(
        name        => $filename,
        maxinterval => 15,
        interval    => 10,
        adjustafter => 20,
        nowait      => 1,
        tail        => -1
    );
    $tail->pos_storage($filename.'.pos');
    
    while (defined(my $string = $tail->read)) {
        ...
        ...
        $tail->save_position;
    }
    
=head1 OBJECT METHODS

=head2 pos_storage($filename)

Add a file which will store data about the position

=cut
sub File::Tail::pos_storage {
    my ($self, $file) = @_;
    $self->{__pos_file} = $file;
    if (-e $file) {
        open(PSF, "<".$file) or die $!;
         my $pos = <PSF>;
        close(PSF);
        $self->{curpos} = sysseek($self->{handle}, $pos || 0, File::Tail::SEEK_SET());
    } else {
        open(PSF, ">".$file) or die $!;
        close(PSF);
    }
    return;
}

=head2 save_position()

Update position

=cut
sub File::Tail::save_position {
    my ($self, $pos) = @_;
    return unless $self->{__pos_len};
    
    open(PSF, "<".$self->{__pos_file}) or die $!;
        my $old_pos = <PSF>;
    close(PSF);
    $old_pos ||= 0;    
    open(PSF, ">".$self->{__pos_file}) or die $!;
        print PSF $old_pos+$self->{__pos_len};
    close(PSF);
    return;
}

my $read_code = \&File::Tail::read;
Sub::Install::reinstall_sub({
    code => sub {
        my $self = shift;
        $self->{__pos_len} = 0;
        my @ret = ();
        if (wantarray()) {
            @ret = $read_code->($self,@_);
        } else {
            my $ret = $read_code->($self,@_);
            @ret = ($ret);
        };
        $self->{__pos_len} += length $_ for @ret;
        return wantarray() ? @ret : $ret[0];
    },
    into => 'File::Tail',
    as   => 'read'
});

=head1 SEE ALSO

L<File::Tail>, L<Sub::Install>

=head1 AUTHOR

mr.Rico <catamoose at yandex.ru>

=cut

1;
__END__
