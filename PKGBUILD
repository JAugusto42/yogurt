#Manteiner: Jose Augusto <joseaugusto.881@outlook.com>
pkgname=yogurt
pkgver=1.1.2
pkgrel=1
pkgdesc="Another aur helper"
arch=('x86_64')
source=https://github.com/JAugusto42/yogurt/releases/tag/
url=https://github.com/jAugusto42/yogurt
license=('MIT')
depends=(
  'ruby'
  'git'
)
makedepends=(
  'python'
)

  	
source=("https://github.com/JAugusto42/yogurt/archive/$pkgver.tar.gz")
md5sums=('SKIP')

package() {
    cd "$pkgname-$pkgver"
    install -Dm755 "$pkgname" "$pkgdir/usr/bin/$pkgname"
}
