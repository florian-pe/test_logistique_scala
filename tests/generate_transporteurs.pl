#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use JSON::XS;
use Tie::IxHash;

# sudo cpan install Tie::IxHash
# sudo cpan install JSON::XS
# ./generate_transporteurs.pl 10 | jq  > transporteurs.json
# on utilise jq pour indenter le json produit

my $nombre_transporteurs = shift // 26;
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

for (0 .. $nombre_transporteurs - 1) {

    my $start = nombre_aleatoire(0, 24);

    tie my %workSchedule, "Tie::IxHash", (
        start   => sprintf("%02d:00", $start),
        end     => sprintf("%02d:00", ($start + nombre_aleatoire(3,8)) % 24),
    );

    tie my %workArea, "Tie::IxHash", (
        latitude    => nombre_aleatoire(50.5056, 50.7531),
        longitude   => nombre_aleatoire(2.7776, 3.4499),
        radiusInKm  => int(nombre_aleatoire(5, 25))
    );

    tie my %transporteur, "Tie::IxHash",
    (
      id   => "transporteur " . lettres($_),
      workSchedule  => \%workSchedule,
      workArea      => \%workArea,
      maxWeightInKg         => int(nombre_aleatoire(50, 300)),
      maxVolumeInM3         => int(nombre_aleatoire(10, 15)),
      maxPacketWeightInKg   => int(nombre_aleatoire(15, 70)),
      maxSpeedInKmh         => int(nombre_aleatoire(40, 80)),
      costInEuros           => int(nombre_aleatoire(10, 20))
    );

    push $data->{transporteurs}->@*, \%transporteur;
}

say encode_json($data);




