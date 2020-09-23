# == Define: cvmfs::id_map
define cvmfs::id_map(
  Hash[Variant[Integer,String], Integer, 1] $map,
  Stdlib::Absolutepath                      $location = $title
) {
  $_map_content = $map.map |$from_id,$to_id| { "${from_id} ${to_id}" }.join("\n")
  file { $location:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# Created by puppet.\n${_map_content}\n",
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
  ->Mount<| fstype == 'cvmfs' |>
}
