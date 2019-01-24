#Manteiner: Jose Augusto <joseaugusto.881@outlook.com>
pkgname=yogurt
pkgver=r30.db59cdd
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
source=("${pkgname}::git+${url}.git")
md5sums=('SKIP')

pkgver() {
    cd "$srcdir/$pkgname-$pkgver"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
    cd "$srcdir/$pkgname-$pkgver"
  	install -Dm755 yogurt {pkgdir}/usr/bin/yogurt

}
