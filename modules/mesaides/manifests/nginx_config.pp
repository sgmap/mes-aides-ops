define mesaides::nginx_config (
    $is_default = true,
    $use_ssl = false,
    $webroot_path = '/var/www',
    $proxied_endpoint = 'http://localhost:8000',
) {
    include ::nginx

    file { "/etc/nginx/sites-enabled/${name}.conf":
        content => template('mesaides/nginx_config.erb'),
        ensure  => file,
        group   => 'www-data',
        mode    => '600',
        notify  => Service['nginx'],
        owner   => 'www-data',
    }

    if $use_ssl {
        include mesaides::generate_custom_dhparam

        class { ::letsencrypt:
            config => {
                email => 'contact@mes-aides.gouv.fr',
            }
        }

        file { $webroot_path:
            ensure => directory,
        }

        letsencrypt::certonly { $name:
            domains       => [ $name ],
            plugin        => 'webroot',
            require       => [ File[$webroot_path], File["/etc/nginx/sites-enabled/${name}.conf"], Service['nginx'] ],
            webroot_paths => [ $webroot_path ],
        }
    }
}