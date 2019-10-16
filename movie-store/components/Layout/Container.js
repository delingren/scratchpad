import Head from 'next/head';
import React from 'react';
import { css } from '@emotion/core';
import { node, string, oneOfType } from 'prop-types';
import { Layout } from 'antd';

const layoutCls = css`
  background: #152530;
  color: #fff;
  font-family: Lato;
`;

const Container = ({ children, title = 'Movie Store' }) => (
  <Layout css={layoutCls} className="layout">
    <Head>
      <title>{title}</title>
    </Head>
    {children}
  </Layout>
);

Container.propTypes = {
  children: oneOfType([node, string]),
  title: string,
};

export default Container;
