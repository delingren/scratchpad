import React from "react";
import Layout from "../components/MyLayout";
import Link from "next/link";
import fetch from "isomorphic-unfetch";

import Markdown from "react-markdown";

export default function Index(props) {
  return (
    <Layout>
      <style jsx>
        {`
          h1,
          a {
            font-family: "Arial";
          }

          ul {
            padding: 0;
          }

          li {
            list-style: none;
            margin: 5px 0;
          }

          a {
            text-decoration: none;
            color: blue;
          }

          a:hover {
            opacity: 0.6;
          }

          .markdown {
            font-family: "Arial";
          }

          .markdown a {
            text-decoration: none;
            color: blue;
          }

          .markdowna: hover {
            opacity: 0.6;
          }

          .markdown h3 {
            margin: 0;
            padding: 0;
            text-transform: uppercase;
          }
        `}
      </style>
      <div className="markdown">
        <Markdown
          source={`
This is a Next.js exercise

### Title
        `}
        />
      </div>

      <h1>Batman TV Show</h1>
      <ul>
        {props.shows.map(show => (
          <li key={show.id}>
            <Link as={`/p/${show.id}`} href={`/post?id=${show.id}`}>
              <a>{show.name}</a>
            </Link>
          </li>
        ))}
      </ul>
      <style jsx>
        {`
          h1,
          a {
            font-family: "Arial";
          }

          ul {
            padding: 0;
          }

          li {
            list-style: none;
            margin: 5px 0;
          }

          a {
            text-decoration: none;
            color: blue;
          }

          a:hover {
            opacity: 0.6;
          }
        `}
      </style>
    </Layout>
  );
}

Index.getInitialProps = async function() {
  const res = await fetch("https://api.tvmaze.com/search/shows?q=batman");
  const data = await res.json();

  console.log(`Show data fetched. Count: ${data.length}`);

  return {
    shows: data.map(entry => entry.show)
  };
};
