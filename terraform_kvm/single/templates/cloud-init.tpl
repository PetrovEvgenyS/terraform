#cloud-config
hostname: ${hostname}          # Устанавливает имя хоста VM.
fqdn: ${hostname}              # Полное доменное имя.
ssh_pwauth: true               # Разрешает аутентификацию по паролю через SSH.

users:                         # Блок конфигурации пользователей.
  - name: ${user_login}        # Имя пользователя.
    plain_text_passwd: ${user_password}  # Пароль пользователя.
    lock_passwd: false         # Не блокировать пароль (разрешить вход).
    shell: /bin/bash           # Оболочка пользователя — bash.
    sudo: ALL=(ALL) ALL        # Права sudo — полный доступ.
    groups: wheel              # Добавление пользователя в группу wheel (для sudo в AlmaLinux).

package_update: true           # Обновление списка пакетов.
package_upgrade: true          # Обновление установленных пакетов.
packages:                      # Установка дополнительных пакетов.
  - qemu-guest-agent           # QEMU Guest Agent для взаимодействия с хостом.
  - vim                        # Текстовый редактор vim.

write_files:                   # Создание файлов на VM.
  - path: /etc/cloud/cloud.cfg.d/99-custom-networking.cfg # Путь к файлу для отключения управления сетью cloud-init.
    permissions: '0600'
    content: |
      network: {config: disabled}
  - path: /etc/NetworkManager/system-connections/eth0.nmconnection  # Путь к файлу конфигурации NetworkManager.
    permissions: "0600"
    content: |
%{ if network_mode == "static" ~}
      [connection]
      id=eth0
      uuid=${uuid}
      type=ethernet
      interface-name=eth0
      autoconnect=true

      [ipv4]
      method=manual
      address=${network.address}
      gateway=${network.gateway}
      dns=${network.dns}

      [ipv6]
      method=disabled
%{ else ~}
      [connection]
      id=eth0
      uuid=${uuid}
      type=ethernet
      interface-name=eth0
      autoconnect=true

      [ipv4]
      method=auto

      [ipv6]
      method=disabled
%{ endif ~}

runcmd:                                       # Команды, выполняемые после настройки.
  - nmcli connection delete "System eth0"     # Удаление старого соединения "System eth0" (если есть).
  - nmcli connection load /etc/NetworkManager/system-connections/eth0.nmconnection  # Загрузка нового соединения.
  - nmcli connection up eth0                  # Активация соединения eth0.
  - systemctl enable --now qemu-guest-agent   # Включение и запуск QEMU Guest Agent.

final_message: "AlmaLinux instance is ready!" # Сообщение, отображаемое после завершения настройки.