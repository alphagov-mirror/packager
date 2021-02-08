class Tiff < FPM::Cookery::Recipe
  description "tiff"

  name "tiff"
  version "2.4.0"
  maintainer "GOV.UK <govuk-dev@digital.cabinet-office.gov.uk>"
  source "https://download.osgeo.org/libtiff/tiff-#{version}.tar.gz"
  sha256 "eb0484e568ead8fa23b513e9b0041df7e327f4ee2d22db5a533929dfc19633cb"

  def build
    configure
    make
  end

  def install
    make install: destdir
  end
end
