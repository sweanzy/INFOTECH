CREATE DATABASE TeknikServis;
GO

USE TeknikServis;
GO

CREATE TABLE Iller(
IlID INT PRIMARY KEY IDENTITY(1,1),
IlAdi NVARCHAR(100)
);

CREATE TABLE Ilceler(
IlceID INT PRIMARY KEY IDENTITY(1,1),
IlID INT NOT NULL,
IlceAdi NVARCHAR(100),
FOREIGN KEY(IlID) REFERENCES Iller(IlID)
);

CREATE TABLE Mahalle(
MahalleID INT PRIMARY KEY IDENTITY(1,1),
IlID INT NOT NULL,
IlceID INT NOT NULL,
MahalleAdi NVARCHAR(100),
FOREIGN KEY(IlID) REFERENCES Iller(IlID),
FOREIGN KEY(IlceID) REFERENCES Ilceler(IlceID)
);

CREATE TABLE Musteriler(
MusteriID INT PRIMARY KEY IDENTITY(1,1),
Eposta NVARCHAR(100),
Ad NVARCHAR(100),
Soyad NVARCHAR(100),
TelefonNumarasi NVARCHAR(20),
MusteriTipi NVARCHAR(50) CHECK(MusteriTipi IN('Bireysel','Kurumsal')),
KayitTarihi DATETIME DEFAULT GETDATE()
);

CREATE TABLE PersonelRolleri(
PersonelRolID INT PRIMARY KEY IDENTITY(1,1),
Roladi NVARCHAR(100)
);

CREATE TABLE Uzmanliklar(
UzmanlikID INT PRIMARY KEY IDENTITY(1,1),
PersonelRolID INT NOT NULL,
UzmanlikAd NVARCHAR(100),
FOREIGN KEY(PersonelRolID) REFERENCES PersonelRolleri(PersonelRolID)
);

CREATE TABLE Personeller(
PersonelID INT PRIMARY KEY IDENTITY(1,1),
PersonelRolID INT NOT NULL,
UzmanlikID INT NOT NULL,
Adi NVARCHAR(30),
Soyad NVARCHAR(30),
Telefon NVARCHAR(20),
Eposta NVARCHAR(250),
FOREIGN KEY(PersonelRolID) REFERENCES PersonelRolleri(PersonelRolID),
FOREIGN KEY(UzmanlikID) REFERENCES Uzmanliklar(UzmanlikID)
);

CREATE TABLE PersonelIzin(
PersonelIzinID INT PRIMARY KEY IDENTITY(1,1),
PersonelID INT NOT NULL,
IzinTarihi DATE NULL,
FOREIGN KEY(PersonelID) REFERENCES Personeller(PersonelID)
);

CREATE TABLE MusteriYetkilisi(
MusteriYetkilisiID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
PersonelID INT NOT NULL,
BaslangicTarihi DATETIME DEFAULT GETDATE(),
BitisTarihi DATETIME DEFAULT NULL,
Aciklama TEXT,
FOREIGN KEY(MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY(PersonelID) REFERENCES Personeller(PersonelID)
);

CREATE TABLE Adresler(
AdresID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
IlceID INT NOT NULL,
IlID INT NOT NULL,
MahalleID INT NOT NULL,
AcikAdres NVARCHAR(255) NOT NULL,
PostaKodu NVARCHAR (20) NULL,
AdresBasligi NVARCHAR (50)NULL,
VarsayilanMi BIT DEFAULT 0,
FOREIGN KEY(MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY(IlceID) REFERENCES Ilceler(IlceID),
FOREIGN KEY(IlID) REFERENCES Iller(IlID),
FOREIGN KEY(MahalleID) REFERENCES Mahalle(MahalleID)
);

CREATE TABLE Vergiler(
VergiID INT PRIMARY KEY IDENTITY(1,1),
Adi NVARCHAR(100) NOT NULL,
Oran DECIMAL(10,2) NOT NULL,
GecerlilikTarihi DATE NOT NULL
);

CREATE TABLE OdemeYontemi(
OdemeYontemiID INT PRIMARY KEY IDENTITY(1,1),
YontemAdi NVARCHAR(100) NOT NULL
);

CREATE TABLE KrediKartlari(
KartID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
Adi NVARCHAR(100),
VarsayilanMi BIT DEFAULT 0,
SKT NVARCHAR(5)NOT NULL,
SahipAdi NVARCHAR(100),
FOREIGN KEY(MusteriID) REFERENCES Musteriler(MusteriID)
);

CREATE TABLE Kategoriler(
KategoriID INT PRIMARY KEY IDENTITY(1,1),
UstKategoriID INT NULL,
Adi NVARCHAR(100) NOT NULL,
Aciklama TEXT,
FOREIGN KEY(UstKategoriID) REFERENCES Kategoriler(KategoriID)
);

CREATE TABLE Tedarikciler(
TedarikciID INT PRIMARY KEY IDENTITY(1,1),
Adi NVARCHAR(255) NOT NULL,
Telefon NVARCHAR(20) NOT NULL,
Eposta NVARCHAR(255) NOT NULL,
Adres NVARCHAR(255) NOT NULL
);

CREATE TABLE Markalar(
MarkaID INT PRIMARY KEY IDENTITY(1,1),
Adi NVARCHAR(255)NOT NULL
);

CREATE TABLE Modeller(
ModelID INT PRIMARY KEY IDENTITY(1,1),
MarkaID INT NOT NULL,
Adi NVARCHAR(100) NOT NULL,
FOREIGN KEY(MarkaID) REFERENCES Markalar(MarkaID)
);

CREATE TABLE Cihazlar(
CihazID INT PRIMARY KEY IDENTITY(1,1),
KategoriID INT NOT NULL,
MarkaID INT NOT NULL,
ModelID INT NOT NULL,
VergiID INT NOT NULL,
AnaCihazID INT NULL,
Ad NVARCHAR(255) NOT NULL,
Fiyat DECIMAL(10,2) NOT NULL,
StokMiktari INT DEFAULT 0, 
Aciklama TEXT,
FOREIGN KEY(KategoriID) REFERENCES Kategoriler(KategoriID),
FOREIGN KEY(MarkaID) REFERENCES Markalar(MarkaID),
FOREIGN KEY(VergiID) REFERENCES Vergiler(VergiID),
FOREIGN KEY(AnaCihazID) REFERENCES Cihazlar(CihazID),
FOREIGN KEY(ModelID) REFERENCES Modeller(ModelID)
);



CREATE TABLE Aksesuar(
AksesuarID INT PRIMARY KEY IDENTITY(1,1),
TedarikciID INT NOT NULL,
MarkaID INT NOT NULL,
ModelID INT NOT NULL,
Fiyat DECIMAL(10,2) NOT NULL,
BirimFiyat DECIMAL(10,2) NOT NULL,
AksesuarAdi NVARCHAR(255),
FOREIGN KEY(TedarikciID) REFERENCES Tedarikciler(TedarikciID),
FOREIGN KEY(ModelID) REFERENCES Modeller(ModelID),
FOREIGN KEY(MarkaID) REFERENCES Markalar(MarkaID)
);

CREATE TABLE ParcaKategorileri(
ParcaKategoriID INT PRIMARY KEY IDENTITY(1,1),
ParcaUstKategoriID INT NULL,
Adi NVARCHAR(100) NOT NULL,
Aciklama TEXT,
FOREIGN KEY(ParcaUstKategoriID) REFERENCES ParcaKategorileri(ParcaKategoriID)
);

CREATE TABLE YedekParca(
YedekParcaID INT PRIMARY KEY IDENTITY(1,1),
ParcaKategoriID INT NOT NULL,
TedarikciID INT NOT NULL,
MarkaID INT NOT NULL,
ModelID INT NOT NULL,
FOREIGN KEY (ParcaKategoriID) REFERENCES ParcaKategorileri(ParcaKategoriID),
FOREIGN KEY(TedarikciID) REFERENCES Tedarikciler(TedarikciID),
FOREIGN KEY(MarkaID) REFERENCES Markalar(MarkaID),
FOREIGN KEY(ModelID) REFERENCES Modeller(ModelID)
);

CREATE TABLE StokHareketleri(
StokHareketleriID INT PRIMARY KEY IDENTITY(1,1),
YedekParcaID INT NULL,
AksesuarID INT  NULL,
CihazID INT  NULL,
StoktaVarMi BIT DEFAULT 1, 
FOREIGN KEY(YedekParcaID) REFERENCES YedekParca(YedekParcaID),
FOREIGN KEY(AksesuarID) REFERENCES Aksesuar(AksesuarID),
FOREIGN KEY(CihazID) REFERENCES Cihazlar(CihazID)
);

CREATE TABLE CihazGorselleri(
GorselID INT PRIMARY KEY IDENTITY(1,1),
CihazID INT NOT NULL,
HexDosyaAdi NVARCHAR(32) UNIQUE NOT NULL,
EklenmeTarihi DATETIME DEFAULT GETDATE(),
FOREIGN KEY(CihazID) REFERENCES Cihazlar(CihazID)
);


CREATE TABLE KargoSirketi(
SirketID INT PRIMARY KEY IDENTITY(1,1),
Adi NVARCHAR(100)NOT NULL,
Ucret DECIMAL(10,2) NOT NULL,
TahminiTeslimSüresi NVARCHAR(50)
);

CREATE TABLE MusteriCihazlari(
MusteriCihazID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
MusteriYetkilisiID INT NOT NULL,
AdresID INT NOT NULL,
SirketID INT NOT NULL,
OdemeYontemiID INT NOT NULL,
KartID INT,
GarantiBaslangicTarihi DATETIME,
GarantiBitisTarihi DATETIME DEFAULT DATEADD(YEAR, 2, GETDATE()),
SiparisTarihi DATETIME DEFAULT GETDATE(),
ToplamTutar DECIMAL(10,2) NOT NULL,
TamirDurumu NVARCHAR(50),
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY (AdresID) REFERENCES Adresler(AdresID),
FOREIGN KEY (SirketID) REFERENCES KargoSirketi(SirketID),
FOREIGN KEY (OdemeYontemiID) REFERENCES OdemeYontemi(OdemeYontemiID),
FOREIGN KEY (KartID) REFERENCES KrediKartlari(KartID),
FOREIGN KEY (MusteriYetkilisiID) REFERENCES MusteriYetkilisi(MusteriYetkilisiID)
);

CREATE TABLE ArizaTipleri(
ArizaTipiID INT PRIMARY KEY IDENTITY(1,1),
ArizaAdi NVARCHAR(100) NOT NULL,
ArizaTürü NVARCHAR(100) NOT NULL,
Aciliyet INT CHECK(Aciliyet BETWEEN 1 AND 5),
Aciklama TEXT
);

CREATE TABLE CihazDetaylari(
CihazDetayID INT PRIMARY KEY IDENTITY(1,1),
MusteriCihazID INT NOT NULL,
CihazID INT NOT NULL,
GorselID INT NOT NULL,
ArizaTipiID INT NOT NULL,
Miktar INT NOT NULL,
BirimFiyat DECIMAL(10,2) NOT NULL,
ToplamFiyat AS(BirimFiyat * Miktar) PERSISTED,
FOREIGN KEY(MusteriCihazID) REFERENCES MusteriCihazlari(MusteriCihazID),
FOREIGN KEY(CihazID) REFERENCES Cihazlar(CihazID),
FOREIGN KEY(GorselID) REFERENCES CihazGorselleri(GorselID),
FOREIGN KEY(ArizaTipiID) REFERENCES ArizaTipleri(ArizaTipiID)
);


CREATE TABLE Faturalar(
FaturaID INT PRIMARY KEY IDENTITY(1,1),
FaturaTuru NVARCHAR(10) CHECK(FaturaTuru IN('Bireysel', 'Kurumsal')),
MusteriCihazID INT NULL,
ToplamTutar DECIMAL(10,2) NOT NULL,
ToplamVergi DECIMAL(10,2) NOT NULL,
FaturaTarihi DATETIME DEFAULT GETDATE(),
FOREIGN KEY(MusteriCihazID) REFERENCES MusteriCihazlari(MusteriCihazID)
);

CREATE TABLE FaturaKalemleri(
FaturaKalemID INT PRIMARY KEY IDENTITY(1,1),
FaturaID INT NOT NULL,
CihazID INT NOT NULL,
Miktar INT NOT NULL,
BirimFiyat DECIMAL(10,2) NOT NULL,
VergiOrani DECIMAL(5,2) NOT NULL,
VergiTutari AS(BirimFiyat * Miktar * VergiOrani/100) PERSISTED,
ToplamFiyat AS((BirimFiyat * Miktar) + (BirimFiyat * Miktar * VergiOrani/100)) PERSISTED,
FOREIGN KEY(FaturaID) REFERENCES Faturalar(FaturaID),
FOREIGN KEY(CihazID) REFERENCES Cihazlar(CihazID)
);



CREATE TABLE Randevular( 
RandevuID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
MusteriYetkilisiID INT NOT NULL,
CihazDetayID INT NOT NULL,
RandevuTarihi DATETIME DEFAULT GETDATE(),
RandevuDurumu NVARCHAR(55) NOT NULL,
Aciklama TEXT,
FOREIGN KEY(MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY(MusteriYetkilisiID) REFERENCES MusteriYetkilisi(MusteriYetkilisiID),
FOREIGN KEY(CihazDetayID) REFERENCES CihazDetaylari(CihazDetayID)
);

CREATE TABLE ServisKayitlari(
ServisKayitID INT PRIMARY KEY IDENTITY(1,1),
MusteriYetkilisiID INT NOT NULL,
CihazDetayID INT NOT NULL,
RandevuID INT NOT NULL,
KayýtTarihi DATETIME DEFAULT GETDATE(),
FOREIGN KEY (MusteriYetkilisiID) REFERENCES MusteriYetkilisi(MusteriYetkilisiID),
FOREIGN KEY (CihazDetayID) REFERENCES CihazDetaylari(CihazDetayID),
FOREIGN KEY (RandevuID) REFERENCES Randevular(RandevuID)
);

CREATE TABLE ParcaKullanimi(
ParcaKullanimID INT PRIMARY KEY IDENTITY(1,1),
StokHareketleriID INT NOT NULL,
CihazDetayID INT NOT NULL,
FOREIGN KEY (StokHareketleriID) REFERENCES StokHareketleri(StokHareketleriID),
FOREIGN KEY (CihazDetayID) REFERENCES CihazDetaylari(CihazDetayID)
);


CREATE TABLE ServisIslemleri(
ServisIslemiID INT PRIMARY KEY IDENTITY(1,1),
ServisKayitID INT NOT NULL,
IslemBaslangicTarihi DATETIME DEFAULT GETDATE(),
TahminiBitisSuresi AS DATEADD(DAY,30 ,IslemBaslangicTarihi),
FOREIGN KEY(ServisKayitID) REFERENCES ServisKayitlari(ServisKayitID)
);

CREATE TABLE ServisDurumlari(
ServisDurumID INT PRIMARY KEY IDENTITY(1,1),
ServisIslemiID INT NOT NULL,
DurumAdi NVARCHAR(100) NOT NULL,
DurumAciklama NVARCHAR(150) NOT NULL,
AktifMi BIT DEFAULT 1,
FOREIGN KEY(ServisIslemiID) REFERENCES ServisIslemleri(ServisIslemiID)
);

CREATE TABLE DurumGecmisi(
DurumGecmisID INT PRIMARY KEY IDENTITY(1,1),
ServisKayitID INT NOT NULL,
ServisIslemiID INT NOT NULL,
ServisDurumID INT NOT NULL,
BitisTarihi DATETIME NULL,
FOREIGN KEY (ServisKayitID) REFERENCES ServisKayitlari(ServisKayitID),
FOREIGN KEY (ServisIslemiID) REFERENCES ServisIslemleri(ServisIslemiID),
FOREIGN KEY (ServisDurumID) REFERENCES ServisDurumlari(ServisDurumID)
);

CREATE TABLE Tahsilatlar(
TahsilatID INT PRIMARY KEY IDENTITY (1,1),
PersonelID INT NOT NULL,
OdemeYontemiID INT NOT NULL,
FaturaID INT NOT NULL,
ServisKayitID INT NOT NULL,
OdemeTarihi DATETIME NOT NULL DEFAULT GETDATE(),
OdenecekTutar DECIMAL(10,2) NOT NULL,
Aciklama TEXT NULL,
FOREIGN KEY (PersonelID) REFERENCES Personeller(PersonelID),
FOREIGN KEY (FaturaID) REFERENCES Faturalar(FaturaID),
FOREIGN KEY (ServisKayitID) REFERENCES ServisKayitlari(ServisKayitID),
FOREIGN KEY (OdemeYontemiID) REFERENCES OdemeYontemi(OdemeYontemiID)
);


CREATE TABLE KasaHareketleri(
KasaHareketleriID INT PRIMARY KEY IDENTITY(1,1),
TahsilatID INT NOT NULL,
OdemeTarihi DATETIME DEFAULT GETDATE(),
Tutar DECIMAL(10,2),
FOREIGN KEY (TahsilatID) REFERENCES Tahsilatlar(TahsilatID)
);


CREATE TABLE BildirimSablonu(
BildirimSablonID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
MusteriYetkilisiID INT NOT NULL,
ServisDurumID INT NOT NULL,
BildirimTuru NVARCHAR(20) CHECK(BildirimTuru IN ('SMS','Email')) NOT NULL,
Baslik NVARCHAR(200) NOT NULL,
Icerik NVARCHAR(MAX) NOT NULL,
Durum NVARCHAR(20) DEFAULT 'Gönderildi',
GonderimTarihi DATETIME DEFAULT GETDATE(),
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY (MusteriYetkilisiID) REFERENCES MusteriYetkilisi(MusteriYetkilisiID),
FOREIGN KEY (ServisDurumID) REFERENCES ServisDurumlari(ServisDurumID)
);

CREATE TABLE GeriBildirim(
GeriBildirimID INT PRIMARY KEY IDENTITY(1,1),
MusteriID INT NOT NULL,
BildirimSablonID INT NOT NULL,
BildirimTuru NVARCHAR(20) CHECK(BildirimTuru IN ('SMS','Email')) NOT NULL,
Baslik NVARCHAR(200) NOT NULL,
Icerik NVARCHAR(MAX) NOT NULL,
Durum NVARCHAR(20) DEFAULT 'Gönderildi',
GonderimTarihi DATETIME DEFAULT GETDATE(),
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
FOREIGN KEY (BildirimSablonID) REFERENCES BildirimSablonu(BildirimSablonID)
);