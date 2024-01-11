# Maintainer: Jose Augusto <joseaugusto.881@outlook.com>
pkgname=yogurt
pkgver=4.0
pkgrel=1
pkgdesc="Yet another aur helper."
arch=('any')
url="https://github.com/JAugusto42/yogurt"
license=('MIT')
#depends=('ruby')

source=("$pkgname-$pkgver.tar.gz::https://github.com/JAugusto42/yogurt/archive/refs/tags/${pkgver}.tar.gz")

package() {
  cd "$srcdir/$pkgname-$pkgver"
  bash install.sh
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

# SHA256 sum of the source archive
sha256sums=('db04364399b2acb6b5026b56144ca31ad7b11848425eb3d978f325c4a49bde86')
