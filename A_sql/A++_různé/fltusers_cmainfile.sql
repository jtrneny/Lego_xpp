update fltusers set fltusers.cmainfile = filtrs.cmainfile
from filtrs
where fltusers.cidfilters = filtrs.cidfilters