#!/bin/ash


{% for m in mounts|default([]) %}

mkdir -p {{ m.dest }}
grep {{ m.dest }} /etc/fstab || {
    echo '{{ m.src }} {{ m.dest }} {{
             m.type|default("ext4") }} {{
             item.options|default("defaults")
         }} 0 0' >> /etc/fstab
}
mount {{ m.dest }}

{% endfor %}
