include:
  - nginx

{{ pillar['user'] }}:
  user:
    - present
    - shell: /bin/bash
    - home: /home/{{ pillar['user'] }}
    - uid: 2100
    - gid: 2100
    - require:
      - group: {{ pillar['user'] }}
  group:
    - present
    - gid: 2100

/etc/nginx/conf.d/webapp.conf:
  file:
    - managed
    - source: salt://webapp/files/webapp.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

{{ pillar['index_location'] }}/index.html:
  file:
    - managed
    - source: salt://webapp/files/index.html
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 644
    - require:
       - user: {{ pillar['user'] }}
       - file: /etc/nginx/conf.d/webapp.conf
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/default:
  file:
    - absent