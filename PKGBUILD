# Maintainer: Jose Augusto <joseaugusto.881@outlook.com>
pkgname=yogurt
pkgver=3.0
pkgrel=1
pkgdesc="Yet another aur helper."
arch=('any')
url="https://github.com/JAugusto42/yogurt"
license=('MIT')
depends=('ruby')

source=("$pkgname-$pkgver.tar.gz::https://github.com/JAugusto42/yogurt/archive/refs/tags/${pkgver}.tar.gz")

package() {
  cd "$srcdir/$pkgname-$pkgver"
  bash install.sh
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

# SHA256 sum of the source archive
sha256sums=('0f8985b3b80f991322fd3af7d9dbf761b9b561edab4c6d86c35309bb7bf7d1c4')
