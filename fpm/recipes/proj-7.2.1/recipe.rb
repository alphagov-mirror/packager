class PROJ < FPM::Cookery::Recipe
  description "PROJ"

  name "proj"
  version "7.2.1"
  maintainer "GOV.UK <govuk-dev@digital.cabinet-office.gov.uk>"
  source "https://download.osgeo.org/proj/proj-#{version}.tar.gz"
  sha256 "b384f42e5fb9c6d01fe5fa4d31da2e91329668863a684f97be5d4760dbbf0a14"

  chain_package true
  chain_recipes ["../sqlite-3/recipe", "../tiff-4.2.0/recipe"]

  def build
    ENV["SQLITE3_CFLAGS"] = "#{builddir}/../../sqlite-3/tmp-build/sqlite-autoconf-3340100/"
    ENV["SQLITE3_LIBS"] = "#{builddir}/../../sqlite-3/tmp-build/sqlite-autoconf-3340100/.libs/"
    ENV["PATH"] = "#{builddir}/../../sqlite-3/tmp-build/sqlite-autoconf-3340100:#{ENV["PATH"]}"
    ENV["TIFF_CFLAGS"] = "#{builddir}/../../sqlite-3/tmp-build/tiff-4.2.0/"
    ENV["TIFF_LIBS"] = "#{builddir}/../../sqlite-3/tmp-build/tiff-4.2.0/.libs/"
    configure
    make
  end

  def install
    make install: destdir
  end
end
