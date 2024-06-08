defmodule AcmeWeb.Expo do
  use Phoenix.Component

  def scripts do
    File.read(Path.join(:code.priv_dir(:acme), "static/public/expo/manifest.json"))
    |> case do
      {:ok, file} ->
        file
        |> Jason.decode!()
        |> case do
          %{"root" => path} ->
            ["http://localhost:4000/public" <> path]

          _ ->
            []
        end

      {:error, _} ->
        []
    end
  end

  def styles(assigns) do
    ~H"""
    <style id="expo-reset">
       /**
      * Extend the react-native-web reset:
      * https://github.com/necolas/react-native-web/blob/master/packages/react-native-web/src/exports/StyleSheet/initialRules.js
      */
       html,
       body,
       #root {
         width: 100%;
         /* To smooth any scrolling behavior */
         -webkit-overflow-scrolling: touch;
         margin: 0px;
         padding: 0px;
         /* Allows content to fill the viewport and go beyond the bottom */
         min-height: 100%;
       }
       #root {
         flex-shrink: 0;
         flex-basis: auto;
         flex-grow: 1;
         display: flex;
         flex: 1;
       }

       html {
         /* Prevent text size change on orientation change https://gist.github.com/tfausak/2222823#file-ios-8-web-app-html-L138 */
         -webkit-text-size-adjust: 100%;
         height: calc(100% + env(safe-area-inset-top));
         scrollbar-gutter: stable both-edges;
       }
       html,
       body {
         font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
           "Liberation Sans", Helvetica, Arial, sans-serif;
       }

       #preload {
         width: 100px;
         position: fixed;
         left: 50%;
         top: 50%;
         transform: translate(-50%, -50%);
       }

       /* Buttons and inputs have a font set by UA, so we'll have to reset that */
       button,
       input,
       textarea {
         font: inherit;
         line-height: inherit;
       }

       /* Color theming */
       /* Default will always be white */
       :root {
         --text: black;
         --background: white;
         --backgroundLight: hsl(211, 20%, 95%);
       }
       /* This gives us a black background when system is dark and we have not loaded the theme/color scheme values in JS */
       @media (prefers-color-scheme: dark) {
         :root {
           --text: white;
           --background: black;
           --backgroundLight: hsl(211, 20%, 20%);
           color-scheme: dark;
         }
       }

       /* Overwrite those preferences with the selected theme */
       html.theme--light {
         --text: black;
         --background: white;
         --backgroundLight: hsl(211, 20%, 95%);
       }
       html.theme--dark {
         --text: white;
         --background: black;
         --backgroundLight: hsl(211, 20%, 20%);
         color-scheme: dark;
       }
       html.theme--dim {
         --text: white;
         --background: hsl(211, 20%, 4%);
         --backgroundLight: hsl(211, 20%, 10%);
         color-scheme: dark;
       }

       /* Remove autofill styles on Webkit */
       input:autofill,
       input:-webkit-autofill,
       input:-webkit-autofill:hover,
       input:-webkit-autofill:focus,
       input:-webkit-autofill:active {
         -webkit-background-clip: text;
         -webkit-text-fill-color: var(--text);
         transition: background-color 5000s ease-in-out 0s;
         box-shadow: inset 0 0 20px 20px var(--background);
         background: var(--background);
         color: var(--text);
       }
       /* Force left-align date/time inputs on iOS mobile */
       input::-webkit-date-and-time-value {
         text-align: left;
       }

       body {
         display: flex;
         /* Allows you to scroll below the viewport; default value is visible */
         overflow-y: auto;
         overscroll-behavior-y: none;
         text-rendering: optimizeLegibility;
         background-color: var(--background);
         -webkit-font-smoothing: antialiased;
         -moz-osx-font-smoothing: grayscale;
         -ms-overflow-style: scrollbar;
         font-synthesis-weight: none;
       }

       /* Remove default link styling */
       a {
         color: inherit;
       }
       a[role="link"]:hover {
         text-decoration: underline;
       }
       a[role="link"][data-no-underline="1"]:hover {
         text-decoration: none;
       }

       /* Styling hacks */
       *[data-word-wrap] {
         word-break: break-word;
       }
       *[data-stable-gutters] {
         scrollbar-gutter: stable both-edges;
       }

       textarea:focus,
       input:focus {
         outline: 0;
       }
       .tippy-content .items {
         width: fit-content;
       }

       /* Tooltips */
       [data-tooltip] {
         position: relative;
         z-index: 10;
       }
       [data-tooltip]::after {
         content: attr(data-tooltip);
         display: none;
         position: absolute;
         bottom: 0;
         left: 50%;
         transform: translateY(100%) translateY(8px) translateX(-50%);
         padding: 4px 10px;
         border-radius: 10px;
         background: var(--backgroundLight);
         color: var(--text);
         text-align: center;
         white-space: nowrap;
         font-size: 12px;
         z-index: 10;
       }
       [data-tooltip]::before {
         content: "";
         display: none;
         position: absolute;
         border-bottom: 6px solid var(--backgroundLight);
         border-left: 6px solid transparent;
         border-right: 6px solid transparent;
         bottom: 0;
         left: 50%;
         transform: translateY(100%) translateY(2px) translateX(-50%);
         z-index: 10;
       }
       [data-tooltip]:hover::after,
       [data-tooltip]:hover::before {
         display: block;
       }

       /* NativeDropdown component */
       .radix-dropdown-item:focus,
       .nativeDropdown-item:focus {
         outline: none;
       }

       /* Spinner component */
       @keyframes rotate {
         0% {
           transform: rotate(0deg);
         }
         100% {
           transform: rotate(360deg);
         }
       }
       .rotate-500ms {
         position: absolute;
         inset: 0;
         animation: rotate 500ms linear infinite;
       }

       @keyframes avatarHoverFadeIn {
         from {
           opacity: 0;
         }
         to {
           opacity: 1;
         }
       }

       @keyframes avatarHoverFadeOut {
         from {
           opacity: 1;
         }
         to {
           opacity: 0;
         }
       }
    </style>
    """
  end
end
