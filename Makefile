legislators-current.json:
	curl -o $@ https://unitedstates.github.io/congress-legislators/legislators-current.json

committee_summary_2024.csv:
	curl -o $@ https://cg-519a459a-0ea3-42c2-b7bc-fa1143481f74.s3-us-gov-west-1.amazonaws.com/bulk-downloads/2024/committee_summary_2024.csv


sf-facilities.geojson:
	curl -o $@ 'https://data.sfgov.org/api/geospatial/nc68-ngbr?fourfour=nc68-ngbr&accessType=DOWNLOAD&method=export&format=GeoJSON'

demo.db: congress.sql fec.sql sf-facilities.sql legislators-current.json committee_summary_2024.csv sf-facilities.geojson
	uv run solite run $@ congress.sql
	uv run solite run $@ fec.sql
	uv run solite run $@ sf-facilities.sql