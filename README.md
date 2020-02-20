# SoalShiftSISOP20_modul1_F06
## Contents
- [Soal 1](#Soal-1)
	- [a](#a-tentukan-wilayah-bagian-region-mana-yang-memiliki-keuntungan-profit-paling-sedikit)
	- [b](#b-tampilkan-2-negara-bagian-state-yang-memiliki-keuntungan-profit-paling-sedikit-berdasarkan-hasil-poin-a)
	- [c](#c-tampilkan-10-produk-product-name-yang-memiliki-keuntungan-profit-paling-sedikit-berdasarkan-2-negara-bagian-state-hasil-poin-b)
- [Soal 2](#Soal-2)
	- [a/b](#a-membuat-sebuah-script-bash-yang-dapat-menghasilkan-password-secara-acak-sebanyak-28-karakter-yang-terdapat-huruf-besar-huruf-kecil-dan-angka--b-password-acak-tersebut-disimpan-pada-file-berekstensi-txt-dengan-nama-berdasarkan-argumen-yang-diinputkan-dan-hanya-berupa-alphabet)
	- [c](#c-kemudian-supaya-file-txt-tersebut-tidak-mudah-diketahui-maka-nama-filenya-akan-di-enkripsi-dengan-menggunakan-konversi-huruf-string-manipulation-yang-disesuaikan-dengan-jam0-23-dibuatnya-file-tersebut)
	- [d](#d-membuat-dekripsinya-supaya-nama-file-bisa-kembali)
- [Soal 3](#Soal-3)
	- [a](#a-maka-dari-itu-kalian-mencoba-membuat-script-untuk-mendownload-28-gambar-dari--httpsloremflickrcom320240cat--menggunakan-command-wget-dan-menyimpan-file-dengan-nama-pdkt_kusuma_no-contoh-pdkt_kusuma_1-pdkt_kusuma_2-pdkt_kusuma_3-serta-jangan-lupa-untuk-menyimpan-log-messages-wget-kedalam-sebuah-file-wgetlog-)
	- [b](#b-karena-kalian-gak-suka-ribet-kalian-membuat-penjadwalan-untukmenjalankan-script-download-gambar-tersebut-namun-script-download-tersebut-hanya-berjalan-setiap-8-jam-dimulai-dari-jam-605-setiap-hari-kecuali-hari-sabtu)
	- [c](#c-maka-dari-itu-buatlah-sebuah-script-untuk-mengidentifikasi-gambar-yang-identik-dari-keseluruhan-gambar-yang-terdownload-tadi-bila-terindikasi-sebagai-gambar-yang-identik-maka-sisakan-1-gambar-dan-pindahkan-sisa-file-identik-tersebut-ke-dalam-folder-duplicate-dengan-format-filename-duplicate_nomor-contoh--duplicate_200-duplicate_201-setelah-itu-lakukan-pemindahan-semua-gambar-yang-tersisa-kedalam-folder-kenangan-dengan-format-filename-kenangan_nomor-contoh-kenangan_252-kenangan_253-setelah-tidak-ada-gambar-di-current-directory--maka-lakukan-backup-seluruh-log-menjadi-ekstensi-logbak)
		
## Soal 1
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum
untuk membuat laporan berdasarkan data yang ada pada file “Sample-Superstore.tsv”.
Namun dia tidak dapat menyelesaikan tugas tersebut

### a. Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling sedikit

#### Penyelesaian
Menggunakan awk. Berikut merupakan kode awk-nya.
~~~
awk 'BEGIN {FS="\t"; PROCINFO["sorted_in"]="@val_num_asc"}
FNR>1 {reg[$13]+=$21}
END {for(i in reg) print i, reg[i]}' Sample-Superstore.tsv |
awk '{print $1}' | head -1
~~~
Penjelasan:
- Dalam block **BEGIN** 
	- `FS=\"t"` artinya data yang diinput menggunakan "tab" sebagai pembatas kolom.
	- `PROCINFO["sorted_in"]="@val_num_asc"` merupakan fitur yang digunakan untuk meng-scan array menurut value-nya yang berupa numeric secara ascending (kecil ke besar)
- Dalam block **body**
	- `FNR>1` artinya mengabaikan row pertama (yang dalam data ini merupakan title atau atribut)
	- `{reg[$13]+=$21}` mengisi array reg dengan jumlah "profit" (kolom 21) di mana index array reg adalah data pada kolom 13
- Dalam block **END**
	- `{for(i in reg) print i, reg[i]}` iterasi array reg dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `Sample-Superstore.tsv` nama file yang menjadi input
- `awk '{print $1}'` mencetak kolom pertama dari hasil awk yang sebelumnya
- `head -1` membatasi hanya row pertama saja yang ditampilkan

### b. Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a

#### Penyelesaian
Menggunakan awk, dan memanfaatkan hasil dari a. Berikut merupakan kode awk-nya.
~~~
awk -v min_region="$min_region" 'BEGIN {FS="\t"; PROCINFO["sorted_in"]="@val_num_asc"}
($13~min_region) {state[$11]+=$21}
END{for(i in state) print i, state[i]}' Sample-Superstore.tsv |
awk '{print $1}' | head -2
~~~
Penjelasan:
- `-v min_region="$min_region"` -v merupakan command untuk mendeklarasikan variable min_region di mana valuenya adalah hasil dari perintah sebelumnya
- Dalam block **BEGIN** sama seperti sebelumnya
- Dalam block **body**
	- `($13~min_region)` mencari pattern pada kolom 13 yang memiliki data sama dengan min_region 
	- `{state[$11]+=$21}` mengisi array state dengan jumlah "profit" (kolom 21) di mana index array state adalah data pada kolom 11
- Dalam block **END**
	- `for(i in state) print i, state[i]` iterasi array state dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `head -2` hanya menampilkan dua row teratas

### c. Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling sedikit berdasarkan 2 negara bagian (state) hasil poin b

#### Penyelesaian
Menggunakan awk, dan memanfaatkan hasil dari b. Berikut merupakan kode awk-nya.
~~~
state1="Texas"
state2="Illinois"
awk -v state1="$state1" -v state2="$state2" 'BEGIN {FS="\t"; OFS="\t";
 PROCINFO["sorted_in"]="@val_num_asc"}
($11~state1 || $11~state2) {produk[$17]+=$21}
END{for(i in produk)print i,produk[i]}' Sample-Superstore.tsv |
awk 'BEGIN{FS="\t"}; {print $1}' | head -10
~~~
Penjelasan:
- `state1="Texas" state2="Illinois"` mendeklarasikan variable state1 dengan value "Texas" (didapat dari hasil b) dan state2 dengan value 
"Illinois" (yang juga didapat dari hasil b)
- Dalam block **BEGIN**
	- kurang lebih sama dengan yang sebelumnya, yang berbeda terdapat `OFS="\t"` yang berarti batas antar kolom pada output adalah tab
- Dalam block **body**
	- `($11~state1 || $11~state2)` mencari pattern pada kolom 11 yang memiliki data sama dengan state1 (Texas) atau state2 (Illinois)
	- `{produk[$17]+=$21}` mengisi array produk dengan jumlah "profit" (kolom 21) di mana index array produk adalah data pada kolom 17
- Dalam block **END**
	- `for(i in produk) print i, produk[i]` iterasi array produk dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `Sample-Superstore.tsv | awk 'BEGIN{FS="\t"}; {print $1}' | head -10`
	- `awk 'BEGIN{FS="\t"}` artinya data yang diinput (dalam hal ini merupakan output dari perintah sebelumnya) menggunakan "tab" sebagai pembatas kolom.
	- `head -10` menampilkan 10 row teratas

#### Hasil
![output_soal1](https://github.com/neutralix/SoalShiftSISOP20_modul1_F06/blob/master/output_soal1.png)

## Soal 2
Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting.
Untuk mencegah kejadian yang sama terulang kembali mereka
meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide.
Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide
tersebut cepat diselesaikan.

### a. Membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka. // b. Password acak tersebut disimpan pada file berekstensi .txt dengan nama berdasarkan argumen yang diinputkan dan HANYA berupa alphabet.

#### Penyelesaian
Menggunakan command untuk melakukan random generate character dan disimpan ke sebuah file dengan nama sesuai argumen yang diterima.
~~~
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1 > "$1".txt
~~~
Penjelasan:
- `cat` digunakan untuk menampilkan isi file, dalam kasus ini isi file berasal dari command /dev/urandom.
- `/dev/urandom` digunakan untuk memanggil perintah yang dapat me-random karakter secara pseudorandom.
- `tr -dc 'a-zA-Z0-9'` mengatur agar karakter yang di-random merupakan alfabet dan angka.
- `fold -w 28` jumlah karakter yang di-random sepanjang 28 karakter.
- `head -n 1` membuat satu baris string random.
- `> "$1".txt` melakukan redirection (menyimpan output ke file) dengan nama sesuai argumen.

### c. Kemudian supaya file .txt tersebut tidak mudah diketahui maka nama filenya akan di enkripsi dengan menggunakan konversi huruf (string manipulation) yang disesuaikan dengan jam(0-23) dibuatnya file tersebut.

#### Penyelesaian
Memanipulasi nama file yang diakses sedemikian sehingga string asalnya berubah/bergeser beberapa alfabet tergantung dari jamnya. Pertama harus melakukan ekstrak nama file dan mendapatkan jam "last-modified" file tersebut yang digunakan untuk acuan enkripsi.
~~~
newfile=`basename -s .txt $1`
hour=$(date +"%H" -r $1)

while [ $hour -gt 0 ]
do
	newfile=$(echo "$newfile" | tr '[A-Za-z]' '[B-ZAb-za]')
	hour=$((hour-1))
done

mv "$1" "$newfile.txt"
~~~
Penjelasan:
- `basename -s .txt $1` digunakan untuk mendapatkan nama file tanpa ekstensi .txt (-s .txt untuk mengabaikan ekstensi .txt) dari nama file yang diargumenkan/dijalankan script.
- `hour=$(date +"%H" -r $1)` menampilkan waktu dengan format jam saja dari file dengan nama sesuai yang diargumenkan dan disimpan ke variable hour.
- `newfile=$(echo "$newfile" | tr '[A-Za-z]' '[B-ZAb-za]')` melakukan enkripsi(penggeseran) alfabet sebanyak 1 ke kanan. Contohnya abc menjadi bcd. Proses ini diulang sebanyak variable hour. Hasil enkripsi disimpan ke variable newfile.
- `mv "$1" "$newfile.txt"` me-rename file dengan nama yang telah dienkripsi.

### d. Membuat dekripsinya supaya nama file bisa kembali.

#### Penyelesaian
Prinsip yang digunakan sama seperti saat melakukan enkripsi. Yang membedakan adalah kali ini string bergeser lawan arah dari saat enkripsi.
~~~
#!/bin/bash

newfile=`basename -s .txt $1`
hour=$(date +"%H" -r $1)

while [ $hour -gt 0 ]
do
        newfile=$(echo "$newfile" | tr '[A-Za-z]' '[ZA-Yza-y]')
        hour=$((hour-1))
done

mv "$1" "$newfile.txt"
~~~
Penjelasan:
- `newfile=$(echo "$newfile" | tr '[A-Za-z]' '[ZA-Yza-y]')` melakukan enkripsi(penggeseran) alfabet sebanyak 1 ke kiri. Contohnya abc menjadi zab. Proses ini diulang sebanyak variable hour. Hasil dekripsi disimpan ke variable newfile.
- command selebihnya berfungsi sama seperti pada soal c.

## Soal 3
1 tahun telah berlalu sejak pencampakan hati Kusuma. Akankah sang pujaan hati
kembali ke naungan Kusuma? Memang tiada maaf bagi Elen. Tapi apa daya hati yang
sudah hancur, Kusuma masih terguncang akan sikap Elen. Melihat kesedihan Kusuma,
kalian mencoba menghibur Kusuma dengan mengirimkan gambar kucing.

### a. Maka dari itu, kalian mencoba membuat script untuk mendownload 28 gambar dari " https://loremflickr.com/320/240/cat " menggunakan command wget dan menyimpan file dengan nama "pdkt_kusuma_NO" (contoh: pdkt_kusuma_1, pdkt_kusuma_2, pdkt_kusuma_3) serta jangan lupa untuk menyimpan log messages wget kedalam sebuah file "wget.log" .

#### Penyelesaian
Menggunakan command wget untuk melakukan download gambar dari url yang diberikan.
~~~
for ((i=1 ; $i<=28 ; i++))
do
	wget "https://loremflickr.com/320/240/cat" -a "wget.log" -O "pdkt_kusuma_$i"
done
~~~
Penjelasan:
- `wget` command untuk melakukan download
- `-a "wget.log"` opsi tambahan wget untuk selalu melakukan append log download ke file wget.log
- `-O "pdkt_kusuma_$i` opsi tambahan wget untuk menyimpan file yang didownload dengan nama sesuai format tersebut

### b. Karena kalian gak suka ribet, kalian membuat penjadwalan untukmenjalankan script download gambar tersebut. Namun, script download tersebut hanya berjalan setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari Sabtu

#### Penyelesaian
Melakukan task pada crontab dengan format jam tertentu
~~~
5 6-23/8 * * 0-5 Desktop/Modul1/SoalShift/Soal3/soal3.sh
~~~
Penjelasan:
- `5 6-23/8 * * 0-5` setting cron tersebut berarti berjalan setiap 8 jam dimulai dari jam 6.05 bulan apapun selama setiap hari kecuali hari sabtu.
- `Desktop/Modul1/SoalShift/Soal3/soal3.sh` lokasi script yang akan dijalankan

### c. Maka dari itu buatlah sebuah script untuk mengidentifikasi gambar yang identik dari keseluruhan gambar yang terdownload tadi. Bila terindikasi sebagai gambar yang identik, maka sisakan 1 gambar dan pindahkan sisa file identik tersebut ke dalam folder ./duplicate dengan format filename "duplicate_nomor" (contoh : duplicate_200, duplicate_201). Setelah itu lakukan pemindahan semua gambar yang tersisa kedalam folder ./kenangan dengan format filename "kenangan_nomor" (contoh: kenangan_252, kenangan_253). Setelah tidak ada gambar di current directory , maka lakukan backup seluruh log menjadi ekstensi ".log.bak".

#### Penyelesaian
Menggunakan command wget untuk melakukan download gambar dari url yang diberikan.
~~~
kenangancount=$(ls -l kenangan | wc -l)
duplicatecount=$(ls -l duplicate | wc -l)
...
...
for ((i=1 ; $i<=28 ; i++))
do
	for ((j=$((i+1)) ; $j<=28 ; j++))
	do
		value=$(compare -metric AE pdkt_kusuma_$i pdkt_kusuma_$j null: 2>&1)
		if [[ $value == 0 ]]
		then
			mv pdkt_kusuma_$j duplicate/duplicate_$duplicatecount
			duplicatecount=$((duplicatecount+1))
		fi
	done
done

for ((i=1 ; $i<=28 ; i++))
do
	if [[ -f pdkt_kusuma_$i ]]
	then
		mv pdkt_kusuma_$i kenangan/kenangan_$kenangancount
		kenangancount=$((kenangancount+1))
	fi
done

cp wget.log wget.log.bak
~~~
Penjelasan:
- `ls -l kenangan | wc -l` untuk menghitung jumlah banyaknya newline saat melakukan list dengan option -l.
- `compare -metric AE pdkt_kusuma_$i pdkt_kusuma_$j null: 2>&1` melakukan compare gambar dengan option metric absolute error. Command ini akan mengembalikan nilai banyaknya titik berbeda pada gambar. `2>&1` merupakan redirect pesan error agar tidak keluar ke terminal.
- `mv pdkt_kusuma_$j duplicate/duplicate_$duplicatecount` memindahkan file ke folder duplicate.
- `-f pdkt_kusuma_$i` melakukan pengecekan apakah file tersebut ada atau tidak.
- `cp wget.log wget.log.bak` copy file wget.log menjadi wget.log.bak sebagai backup.
