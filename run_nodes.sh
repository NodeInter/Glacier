#!/bin/bash

# Nama folder utama
main_folder="Glacier"

# Pindah ke folder utama
cd $main_folder

# Buat file JSON untuk PM2
pm2_config="pm2-glacier.json"
echo "[" > $pm2_config

# Loop untuk setiap node
for i in $(ls -d node*/ | sed 's#/##'); do
  echo "  {
    \"name\": \"glacier-$i\",
    \"script\": \"$i/verifier_linux_amd64\",
    \"args\": \"--config $i/config.yaml\"
  }," >> $pm2_config
done

# Hapus koma terakhir dan tutup array
sed -i '$ s/,$//' $pm2_config
echo "]" >> $pm2_config

# Jalankan dengan PM2
pm2 start $pm2_config

# Simpan konfigurasi PM2
pm2 save

# Kembali ke direktori awal
cd ..

# Informasi selesai
echo "Semua node dijalankan dengan PM2."
