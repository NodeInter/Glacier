#!/bin/bash

# Nama folder utama
main_folder="$(pwd)" # Mendapatkan path absolut dari folder saat ini

# Path binary verifier
binary_path="$main_folder/verifier_linux_amd64"

# Periksa apakah binary ada
if [ ! -f "$binary_path" ]; then
  echo "Binary verifier_linux_amd64 tidak ditemukan di $binary_path. Jalankan setup_nodes.sh terlebih dahulu."
  exit 1
fi

# Buat file JSON untuk PM2
pm2_config="pm2-glacier.json"
echo "[" > $pm2_config

# Loop untuk setiap folder node
for node_dir in "$main_folder"/node*/; do
  node_dir="${node_dir%/}"
  node_name=$(basename "$node_dir")
  config_file="${node_dir}/config.yaml"

  # Verifikasi bahwa file config.yaml ada
  if [ ! -f "$config_file" ]; then
    echo "Config file not found in $config_file. Skipping $node_name."
    continue
  fi

  # Tambahkan entri ke file konfigurasi PM2
  echo "  {
      \"name\": \"glacier-$node_name\",
      \"script\": \"$binary_path\",
      \"args\": \"--config $config_file\"
  }," >> $pm2_config
done

# Periksa apakah file JSON memiliki konten selain pembuka array
if grep -q "\"name\":" "$pm2_config"; then
  # Hapus koma terakhir dan tutup array
  sed -i '$ s/,$//' $pm2_config
  echo "]" >> $pm2_config

  # Jalankan node dengan PM2
  pm2 start $pm2_config

  # Simpan konfigurasi PM2
  pm2 save

  echo "Semua node dijalankan menggunakan PM2."
else
  # Jika tidak ada node ditemukan
  echo "]" >> $pm2_config
  echo "Tidak ada node yang ditemukan. File konfigurasi PM2 tetap dibuat di $pm2_config, tetapi tidak ada proses yang dijalankan."
fi
