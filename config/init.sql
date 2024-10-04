CREATE USER 'grafanauser'@'%' IDENTIFIED BY 'grafanapass';
GRANT SELECT ON statusdb.* TO 'grafanauser'@'%';
FLUSH PRIVILEGES;
