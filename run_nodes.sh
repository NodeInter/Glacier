#!/bin/bash

# Nama folder utama
main_folder="$(pwd)" # Mendapatkan path absolut dari folder saat ini

# Buat file JSON untuk PM2
pm2_config="pm2-glacier.json"
echo "[" > $pm2_config

# Loop untuk setiap node
for node_dir in "$main_folder"/node*/; do
  node_name=$(basename "$node_dir")
  config_file="$node_dir/config.yaml"
  binary_file="$node_dir/verifier_linux_amd64"

  if [ ! -f "$config_file" ]; then
    echo "Config file not found in $config_file. Skipping $node_name."
    continue
  fi

  echo "  {
    \"name\": \"glacier-$node_name\",
    \"script\": \"$binary_file\",
    \"args\": \"--config $config_file\"
  }," >> $pm2_config
done

# Hapus koma terakhir dan tutup array
sed -i '$ s/,$//' $pm2_config
echo "]" >> $pm2_config

# Jalankan dengan PM2
pm2 start $pm2_config

# Simpan konfigurasi PM2
pm2 save

echo "Semua node dijalankan dengan PM2 menggunakan konfigurasi di $main_folder."
