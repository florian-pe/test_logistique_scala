#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use JSON::XS;
use Tie::IxHash;

# sudo cpan install Tie::IxHash
# sudo cpan install JSON::XS
# ./generate_livraisons.pl 5 | jq  > livraisons.json
# on utilise jq pour indenter le json produit

my $nombre_de_livraisons = shift // 10;
my $data;

# centre Lille
# lattitude = 50.6280
# longitude =  3.0686

# rectangle autour de Lille :
# haut gauche     50.7470   2.7776
# haut droite     50.7531   3.4499
# bas gauche      50.5056   2.8257
# bas droite      50.5187   3.2933

# latitude      => [50.5056 ; 50.7531]
# longitude     => [ 2.7776 ;  3.4499]

sub nombre_aleatoire {
    my ($min, $max) = @_;
    my $delta = $max - $min;
    return $min + (rand(int($delta * 10_000)) % ($delta * 10_000))/10_000
}

sub conversion_base_n {
    my ($number, $base) = @_;
    my @digits;
    my $power = 1;
    do {
        push @digits, ($number % ($base ** $power));
        $number -= $digits[-1];
        $digits[-1] /= $base ** ($power - 1);
        $power++;
    } while($number > 0);
    reverse @digits;
}

sub lettres {
    join "", map { chr 65 + $_ } conversion_base_n(shift, 26);
}

for (0 .. $nombre_de_livraisons - 1) {

    my $start = nombre_aleatoire(0, 24);

    tie my %creneau, "Tie::IxHash", (
        start   => sprintf("%02d:00", $start),
        end     => sprintf("%02d:00", ($start + nombre_aleatoire(3,8)) % 24),
    );

    tie my %coordRetrait, "Tie::IxHash", (
        latitude    => nombre_aleatoire(50.5056, 50.7531),
        longitude   => nombre_aleatoire(2.7776, 3.4499),
    );

    tie my %coordLivraison, "Tie::IxHash", (
        latitude    => nombre_aleatoire(50.5056, 50.7531),
        longitude   => nombre_aleatoire(2.7776, 3.4499),
    );

    tie my %livraison, "Tie::IxHash",
    (
      id                => "livraison " . lettres($_),
      coordRetrait      => \%coordRetrait,
      coordLivraison    => \%coordLivraison,
      creneau           => \%creneau,
      VolumeInM3        => int(nombre_aleatoire(10, 15)),
      PacketWeightInKg  => int(nombre_aleatoire(15, 70)),
    );

    push $data->{livraisons}->@*, \%livraison;
}

say encode_json($data);




