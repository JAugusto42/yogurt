#Manteiner: Jose Augusto <joseaugusto.881@outlook.com>
pkgname=yogurt
pkgver=1.0.0
pkgrel=1
pkgdesc="An aur helper written in ruby"
arch=('x86_64')
url=https://github.com/jAugusto42/yogurt
license=('MIT')
depends=(
  'sudo'
  'git'
  'ruby'
)
makedepends=(
  'ruby'
)
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/jAugusto42/yogurt/archive/${pkgver}.tar.gz")

pkgver() {
    cd "$srcdir/$pkgname-$pkgver"

}

package() {
    cd "$srcdir/$pkgname-$pkgver"
    install -Dm755 yogurt ${pkgdir}/usr/bin/yogurt
}
