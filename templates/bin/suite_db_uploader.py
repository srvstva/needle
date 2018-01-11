#!/usr/bin/env python
import requests
import argparse


def get_release_id(release):
    """Gets the release id corresponding to the
    release name from the api endpoint
    if the corresponding release is not available
    it makes a post request to the endpoint
    and inserts into the database.
    Returns the newly created id"""
    api_endpoint = API_ENDPOINT + 'release'
    r = session.get(api_endpoint, params=dict(results_per_page=1000))
    json_resp = r.json()
    if not 'objects' in json_resp:
        pass

    releases = [o.get('name') for o in json_resp['objects']]
    if release not in releases:
        # Need to update in database
        r = session.post(api_endpoint, json=dict(name=release))
        resp = r.json()
        releaseid = resp['id']
        try:
            r.raise_for_status()
        except requests.HTTPError as e:
            print 'Unable to POST to endpoint'
            print e.message
            exit()
    else:
        for o in json_resp['objects']:
            if o.get('name') == release:
                releaseid = o.get('id')
    return releaseid


def populate_db_results(result_file):
    """Creates a list of results.
    Each list item is a  dictionary containing the
    test details"""
    db_results = []
    with open(result_file) as f:
        for line in f:
            if line.startswith("#"):
                continue
            name, testrun, componentid, categoryid, status, desc = line.strip().split(',')
            row = dict(
                name=name,
                testrun=testrun,
                categoryid=categoryid,
                componentid=componentid,
                status=status,
                desc=desc
            )
            db_results.append(row)
    return db_results


def upload(releaseid, buildid, db_results):
    """Uploads the database rows to the api server
    The post body or payload is a JSON object"""
    count = 0
    for result in db_results:
        json_payload = dict(
            name=result['name'],
            releaseid=releaseid,
            buildid=buildid,
            testidx=result['testrun'],
            description=result['desc'],
            categoryid=result['categoryid'],
            componentid=result['componentid'],
            status=result['status']
        )

        r = session.post(API_ENDPOINT + 'testcase', json=json_payload)
        try:
            r.raise_for_status()
        except requests.HTTPError as e:
            print e.message

        count += 1
    return count


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-r',
        '--release',
        required=True,
        help='Release name'
    )
    parser.add_argument(
        '-v',
        '--version',
        required=True,
        help='The build number'
    )
    parser.add_argument(
        '-f',
        '--file',
        required=True,
        help='The result file'
    )
    parser.add_argument(
        '-e',
        '--endpoint',
        help='API Endpoint(default=10.10.30.37/api)',
        default='http://10.10.30.37/api/'
    )
    opts = parser.parse_args()

    # Create a session to be used by each
    # request.
    # Session allows the connection to be reused
    # thus making it lot faster
    session = requests.session()
    API_ENDPOINT = opts.endpoint

    releaseid = get_release_id(opts.release)
    db_results = populate_db_results(opts.file)
    count = upload(
        releaseid,
        opts.version,
        db_results
    )
    print '%d rows uploaded' % count

