import Link from 'next/link';

function index() {
    return (
        <div>
            Hello next.js.
            <Link href="about">
                <button>Go to about page</button>
            </Link>
        </div>);
}

export default index;