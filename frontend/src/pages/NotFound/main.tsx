import { Link } from 'react-router-dom';

const NotFoundPage = () => {
  return (
    <div className="text-center p-8">
      <h1 className="text-4xl font-bold">404 - Not Found</h1>
      <p className="mt-4">The page you are looking for does not exist.</p>
      <Link to="/" className="mt-6 inline-block text-blue-600 hover:underline">
        Go back to Home
      </Link>
    </div>
  );
};

export default NotFoundPage;
