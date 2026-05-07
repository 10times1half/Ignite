//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An image on your page. Can be vector (SVG) or raster (JPG, PNG, GIF).
public struct Image: InlineElement, LazyLoadable {
    /// The content and behavior of this HTML.
    public var body: some InlineElement { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The path of the image, either relative to the
    /// root of your site, e.g. /images/dog.jpg., or as a web address.
    var path: URL?

    /// Loads an image from one of the built-in icons. See
    /// https://icons.getbootstrap.com for the list.
    var systemImage: String?

    /// An accessibility label for this image, suitable for screen readers.
    var description: String?

    /// Creates a new `Image` instance from the specified path. For an image contained
    /// in your site's assets, this should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// Append `~dark` to the end of filenames for a dark mode version of the image. (`cool-image.svg` and `cool-image~dark.svg`)
    /// Append `@2x` to the end of filenames to supply a higher resoloution version fo the image (`cool-image.png` and `cool-image@2x.png`)
    /// - Parameters:
    ///   - path: The filename of your image relative to the root of your site.
    ///   e.g. /images/welcome.jpg.
    ///   - description: An description of your image suitable for screen readers.
    public init(_ path: String, description: String? = nil) {
        self.path = URL(string: path)
        self.description = description
    }

    /// Creates a new `Image` instance from the name of one of the built-in
    /// icons. See https://icons.getbootstrap.com for the list.
    /// - Parameters:
    ///   - systemName: An image name chosen from https://icons.getbootstrap.com
    ///   - description: An description of your image suitable for screen readers.
    public init(systemName: String, description: String? = nil) {
        self.systemImage = systemName
        self.description = description
    }

    /// Creates a new decorative `Image` instance from the name of an
    /// image contained in your site's assets folder. Decorative images are hidden
    /// from screen readers.
    /// - Parameter name: The filename of your image relative to the root
    /// of your site, e.g. /images/dog.jpg.
    public init(decorative name: String) {
        self.path = URL(string: name)
        self.description = ""
    }

    /// Allows this image to be scaled up or down from its natural size in
    /// order to fit into its container.
    /// - Returns: A new `Image` instance configured to be flexibly sized.
    public func resizable() -> Self {
        var copy = self
        copy.attributes.append(classes: "img-fluid")
        return copy
    }

    /// Sets the accessibility label for this image to a string suitable for
    /// screen readers.
    /// - Parameter label: The new accessibility label to use.
    /// - Returns: A new `Image` instance with the updated accessibility label.
    public func accessibilityLabel(_ label: String) -> Self {
        var copy = self
        copy.description = label
        return copy
    }

    /// Renders a system image into the current publishing context.
    /// - Parameters:
    ///   - icon: The system image to render.
    ///   - description: The accessibility label to use.
    /// - Returns: The HTML for this element.
    private func render(icon: String, description: String) -> Markup {
        var attributes = attributes
        attributes.append(classes: "bi-\(icon)")
        return Markup("<i\(attributes)></i>")
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        if let systemImage {
            return render(icon: systemImage, description: description ?? "")
        } else if let path {
            var attributes = attributes
            attributes.append(customAttributes:
                .init(name: "src", value: path.relativeString),
                .init(name: "alt", value: description ?? ""))
            return Markup("<img\(attributes) />")
        } else {
            return Markup()
        }
    }
}
