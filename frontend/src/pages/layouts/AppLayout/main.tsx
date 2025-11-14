import { Outlet } from 'react-router-dom';

export function AppLayout() {
  return (
    <div className="min-h-screen flex flex-col">
      {/* Header can go here */}
      <header className="bg-gray-100 p-4 shadow">
        <p className="font-bold text-xl">LoveCakes</p>
      </header>
      <main className="flex-grow">
        <Outlet />
      </main>
      {/* Footer can go here */}
      <footer className="bg-gray-100 p-4 text-center text-sm text-gray-600">
        <p>&copy; 2024 LoveCakes. All rights reserved.</p>
      </footer>
    </div>
  );
}
