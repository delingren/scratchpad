import React from 'react';
import Link from 'next/link';

function index() {
  return (
    <div>
      <p>Hello next.js.</p>
      <Link href="about">
        <button type="button">Go to about page</button>
      </Link>
    </div>
  );
}

export default index;
